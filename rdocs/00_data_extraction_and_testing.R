# Instalando pacote microdatasus ----
# pacote de Raphael Saldanha, para download direto via R dos microdados DATASUS, disponível em https://github.com/rfsaldanha

# install.packages("read.dbc", repos = "https://packagemanager.posit.co/cran/2024-07-05")
# 
# remotes::install_github("rfsaldanha/microdatasus")

# Testando opções da vignette do pacote ----

if (!require("pacman")) install.packages("pacman")
p_load(foreign,tidyverse,microdatasus,gganimate)

dados <- fetch_datasus(year_start = 2013, year_end = 2014, uf = "RJ", information_system = "SIM-DO")
dados <- process_sim(dados)

# A documentação pode ser obtida em https://datasus.saude.gov.br/transferencia-de-arquivos/

# Respondendo uma pergunta: As 10 causas básicas de morte mais frequentes, visualizada por tempo, no estado do Rio de Janeiro, entre 2013 e 2014 ----

# Carregando tabela auxiliar da CID, obtida no link da linha 16
CID <- read.dbf("arquivos/documentacao_datasus/Docs_Tabs_CID10/TABELAS/CID10.dbf")
CID$CID10 = factor(CID$CID10)

dados$CAUSABAS = factor(dados$CAUSABAS)

# Juntando as tabelas
dados <- dados %>%
  left_join(CID, by = c("CAUSABAS" = "CID10"))

dados$DESCR = factor(dados$DESCR)

rm(CID)

# Verificando as 10 causas básicas mais comuns

dados %>%
  select(DESCR) %>%
  group_by(DESCR) %>%
  tally() %>%
  arrange(desc(n)) %>%
  head(10)

# Preparando dados para plotar

df <- dados %>%
  count(DESCR, sort = TRUE) %>%
  slice(1:10) %>%
  left_join(dados, by = "DESCR") %>%
  select(-n) %>%
  mutate(DTOBITO = as.Date(DTOBITO)) %>%
  group_by(DESCR, DTOBITO) %>%
  summarise(contagem = n(), .groups = 'drop') %>%
  arrange(DTOBITO) %>%
  group_by(DESCR) %>%
  mutate(n = cumsum(contagem)) %>%
  ungroup()

p1 <- ggplot(df, aes(x = DTOBITO, y = n, color = DESCR)) +
  geom_line(linewidth = 1.2) +
  labs(title = 'Evolução da contagem de óbitos das 10 causas básicas mais comuns',
       x = 'Data do óbito',
       y = 'Contagem',
       color = 'DESCR') +
  theme_classic()

p1_animado <- p1 +
  transition_reveal(DTOBITO) +
  shadow_mark(past = TRUE, future = FALSE)

# Renderizar 
animate(p1_animado, nframes = 100, fps = 10, width = 800, height = 600)

# Salvar
anim_save("p1.gif", animation = p1)
