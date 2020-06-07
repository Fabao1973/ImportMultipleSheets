library(readxl)
library(tidyr)
# nome do arquivo em excel
xl.data <- "MultiDataSheets.xlsx"
# cria objeto com as planilhas do arquivo de dados
sheets <- excel_sheets(path = xl.data)
list_all <- lapply(sheets, 
                   function(x) read_excel(path = xl.data, 
                                          sheet = x, 
                                          col_names = FALSE))
names(list_all) <- sheets
# converte objeto lista em data frame
df <- plyr::ldply(list_all, data.frame)

# trata o data frame
df <- df[4:length(df$.id),]                # Remove as 3 primeiras linhas
df[1,1] = "Cia"                            # Altera o cabe?alho da primeira coluna
colnames(df) = df[1,]                      # Usa primeira linha como cabecalho
df <- df[-1,]                              # Deleta a primeira linha
df <- df[df$Data!="Data",]                 # Excluir linhas com registro "Data" (cabe?alhos)
colSums(is.na(df))                         # Conta "NA" por coluna
df <- df[!is.na(df$AT),]                   # Excluir linhas com registro "NA"
colSums(df =="-")                          # Conta "-" por coluna
df[,3:11] <- sapply(df[,3:11], as.numeric) # Ajusta o tipo de dado das colunas numericas
colSums(is.na(df))                         # Conta "NA" por coluna
str(df)                                    # Checar estrutura do df


