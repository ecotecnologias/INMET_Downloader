### ---------------------------------------------------------------------------------------------- ###
### ---------------------------------------------------------------------------------------------- ###
### ---------------------------------------------------------------------------------------------- ###
### ........................................ R-GetINEMET ......................................... ###
### ---------------------------------------------------------------------------------------------- ###
### ---------------------------------------------------------------------------------------------- ###
### ---------------------------------------------------------------------------------------------- ###

# Cabecalho ####

### Autores: Jean Ricardo Favaretto, Paola Liberalesso Dimperio, Daniel Gustavo Allasia, Debora    ###
### Missio Bayer, Vitor Gustavo Gueler e Jéssica Ribeiro Fontoura                                 ###
### Contatos: jeanfavaretto@mail.ufsm.br, paolaliberalesso.d@gmail.com, dga@ufsm.br,               ###
### deborabayer@gmail.com, vitorgg_hz@hotmail.com e jessica.ribeirofontoura@gmail.com              ###
### ---------------------------------------------------------------------------------------------- ###
### Versao 18/03/2015 00:00                                                                        ###
###                                                                                                ###
###                                                                                                ###
### OBJETIVO                                                                                       ###
###        Realizar o acesso e aquisição das séries temporrais disniveis no portal INMET.       ###
###                                                                                                ###
###                                                                                                ###
### ---------------------------------------------------------------------------------------------- ###

# Bibliotecas ####
bibliotecas<-c("RCurl","pbapply")
# Carregando Bibliotecas
invisible(sapply(bibliotecas, library, character.only = TRUE, quietly = TRUE))

# Entrada ####
message("Carregar o arquivo contendo o codigo das estacoes. Os codigos das estacoes devem ser 
de forma seguencial um a um separados apenas por um ENTER, como o exemplo abaixo:
Exemplo do TXT.
        82336
        82240
        82361
        83364
        83358
        83676
OBS. Tenha certeza que os Codigos das estacoes sao validos.")

# Le o arquivo de estacoes separado por Linhas (ENTER "\t")
estacoescod<-scan(file.choose(), sep = "|")
### ---------------------------------------------------------------------------------------------- ###
#Numero de estacoes
nuest<-length(estacoescod)

# Direitorio de saida
message("Defina a data de inicio do periodo, por exemplo: 01/01/2000")
dataini<-scan(what = "")
message("Defina a data de fim do periodo, por exemplo: 31/12/2015")
datafim<-scan(what = "")

message("Dados para Login-
Usuario de acesso:")
usuario<-scan(what ="") # aaaa#aaaa.com.br
message("Senha de acesso:")
senha<-scan(what ="") 

# Dados para acesso
meusparametros=list(mCod=usuario, mSenha=senha, btnProcesso = " Acessar ")

# Direitorio de saida
message("Defina o local aonde serao salvos os arquivos de saida")
saidir<-choose.dir()

# Prefico e sufixo do link de acesso ao banco de dados
acessoURL<- "http://www.inmet.gov.br/projetos/rede/pesquisa/inicio.php"

# Arquivos de processamento
# Sucesso
estdownsu<-c()

# Barra de progresso
pbMET <- startpb(0, nuest)

  
for(i in 1:nuest){
  
  #Carregando a Barra
  setpb(pbMET, i)
  
  bdURL<-paste0("http://www.inmet.gov.br/projetos/rede/pesquisa/gera_serie_txt.php?&mRelEstacao=",
                estacoescod[i],"&btnProcesso=serie&mRelDtInicio=",dataini,"&mRelDtFim=",datafim,
                "&mAtributos=,,1,1,,,,,,1,1,,1,1,1,1,")
  # Cookies:
  cookies<-getCurlHandle()
  invisible(curlSetOpt(cookiejar="cookies.txt", useragent="Mozilla/5.0", followlocation=TRUE, curl=cookies))
  
  login <- postForm(acessoURL, .params=meusparametros, curl=cookies)
  dados <- getURLContent(bdURL, curl=cookies)
  write(dados,file=paste0(saidir, "\\", estacoescod[i],".txt"))
  estdownsu<-c(estdownsu,estacoescod[i])
}

closepb(pbMET)

# Relatotrio de saida
cat(
  "### -------------------------------------------------------------------------------------- ###","\n",
  "### -------------------------------------------------------------------------------------- ###","\n",
  "### -------------------------------------------------------------------------------------- ###","\n",
  "### ....................................... R-GetINMET ................................... ###","\n",
  "### -------------------------------------------------------------------------------------- ###","\n",
  "### -------------------------------------------------------------------------------------- ###","\n",
  "### -------------------------------------------------------------------------------------- ###","\n",
  
  
  "### Autores: Jean Ricardo Favaretto , Paola Liberalesso Dimperio, Daniel Gustavo Allasia,  ###","\n", 
  "### Debora Missio Bayer, Vitor GustavoGueler e Jéssica Ribeiro Fontoura                   ###","\n",
  "### Contatos: jeanfavaretto@mail.ufsm.br, dga@ufsm.br, paolaliberalesso.d@gmail.com        ###","\n",
  "### deborabayer@gmail.com, vitorgg_hz@hotmail.com e jessica.ribeirofontoura@gmail.com      ###","\n",
  "### -------------------------------------------------------------------------------------- ###","\n",
  "### Versao 18/03/2015 00:00                                                                ###","\n",
  "\n",
  "### .................................. Relatorio de Saida ................................ ###","\n",

  "\n",
  "\n",
  "Tamanho do arquivo de entrada ","\n",
  length(estacoescod),"\n",
  "\n",
  "Numero de downloads efetuados ","\n",
  length(estdownsu),"\n",
  "\n",
  "Codigo das estacoes salvas","\n",
  as.character(estdownsu),"\n",
  "\n", 
  "Termino da operacao","\n",
  as.character(Sys.time()),
  
  file=paste0(saidir,"\\Relatorio.txt"))


