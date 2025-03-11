source("C:/Program Files (x86)/Ministério da Saúde/TabWin/autoexec.r")
sink("script.out")
titulo=""
subtitulo=""
rodape=""
nomemapa=""
grafico.tabwin = function(fundo="white", largura=7){
  library(graphics);
  win.metafile("tabwin%02d.wmf", width=largura, height=largura);
  par(bg=fundo)
}
carrega.tabwin = function(tabela) {
  zz = file("tabwin.out","w");
  cat("Titulo1=",titulo,"\n",file=zz);
  cat("Titulo2=",subtitulo,"\n",file=zz);
  cat("Rodape=",rodape,"\n",file=zz);
  cat("Nomemapa=",nomemapa,"\n",file=zz);
  close(zz);
  write.table(tabela,"tabwin.out",sep=",", col.names=NA, append=TRUE)
}

q()
