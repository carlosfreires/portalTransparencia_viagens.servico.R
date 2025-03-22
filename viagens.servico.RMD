---
title: "Relatório de viagens"
author: "Carlos Freires"
date: "2025-03-21"
output:
  pdf_document: default
  html_document: default
---

# Portal da Transparência

Para os gráficos foram utilizadas as bases de dados públicos de **viagens a serviço** do ano de 2022 que podem ser encontrados no **portal da Transparência**. <https://portaldatransparencia.gov.br/>.

## A proposta é entender os gastos com viagens a serviço para tomar medidas mais eficientes e, com isso, reduzir os custos das viagens a serviço.

## OBTENÇÃO DOS DADOS

```{r}
?read.csv
```

```{r}
viagens <- read.csv(
  Datasets
  file = "E:/Datasets/2019_Viagem.csv",
  sep = ';',
  dec = ','
)
```

### Visualizando as primeiras linhas do dataset

```{r}
head(viagens)
```

### Abrir em outra aba

```{r}
View(viagens)
```

### Verificar dimensões do dataset

```{r}
dim(viagens)
```

### Resumo do dataset - valores min, max, media, mediana...

```{r}
?summary
```

```{r}
summary(viagens)
```

### Summary de uma coluna especifica

```{r}
summary(viagens$Valor.passagens)
```

### Verificar tipo dos dados

### Caso não tenha o **dplyr** instalado, o o pacote deve ser instalado *install.packages("dplyr")*

```{r}
library(dplyr)
```

```{r}
?dplyr::glimpse 
```

```{r}
glimpse(viagens)
```

## TRANSFORMAÇÃO DOS DADOS OBTIDOS

### Convertendo o tipo do dato para tipo Date

```{r}
?as.Date
```

```{r}
viagens$data.inicio <- as.Date(viagens$Período...Data.de.início, "%d/%m/%Y")
```

```{r}
glimpse(viagens)
```

### Formatando a data de inicio - para utilizar apenas Ano/Mês

```{r}
?format
```

```{r}
viagens$data.inicio.formatada <- format(viagens$data.inicio, "%Y-%m")
```

```{r}
viagens$data.inicio.formatada
```

## EXPLORAÇÃO DOS DADOS

### Gerando histograma da coluna passagens

```{r}
hist(viagens$Valor.passagens)
```

### Outro exemplo de histograma - filtrando valores

### Para esse exemplo serão utilizadas as funções filter e select

```{r}
?dplyr::filter
```

```{r}
?dplyr::select
```

### Filtrando os valores das passagens - apenas passagens entre 200 e 5000

```{r}
passagens_fitro <- viagens %>%
  select(Valor.passagens) %>%
  filter(Valor.passagens >= 200 & Valor.passagens <= 5000) 
```

```{r}
passagens_fitro
```

```{r}
hist(passagens_fitro$Valor.passagens)
```

### Verificando os valores min, max, média... da coluna valor

```{r}
summary(viagens$Valor.passagens)
```

### Visualizando os valores em um boxplot

```{r}
boxplot(viagens$Valor.passagens)
```

### Visualizando os valores das passagens - filtro de 200 a 5000

```{r}
boxplot(passagens_fitro$Valor.passagens)
```

### Calculando o desvio padrão

```{r}
sd(viagens$Valor.passagens)
```

### Verificar se existem valores não preenchidos nas colunas do dataframe

```{r}
?is.na 
```

```{r}
?colSums
```

```{r}
colSums(is.na(viagens))
```

### Verifcar a quantidade de categorias da coluna Situação

### Converter para factor

```{r}
viagens$Situação <- factor(viagens$Situação)
```

```{r}
str(viagens$Situação)
```

### Verificar quantidade de registros em cada categoria

```{r}
table(viagens$Situação)
```

### Obtendo os valores em percentual de cada categoria

```{r}
prop.table(table(viagens$Situação))*100
```

## Visualização dos resultados

## 1 - Qual é o valor gasto por órgão em passagens?

### Criando um dataframe com os 15 órgãos que gastam mais

```{r}
library(dplyr)
```

```{r}
p1 <- viagens %>%
  group_by(Nome.do.órgão.superior) %>%
  summarise(n = sum(Valor.passagens)) %>%
  arrange(desc(n)) %>%
  top_n(15)
```

### Alterando o nome das colunas

```{r}
names(p1) <- c("orgao", "valor")
```

```{r}
p1
```

### Plotando os dados com o ggplot

```{r}
library(ggplot2)
```

```{r}
ggplot(p1, aes(x = reorder(orgao, valor), y = valor))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(x = "Valor", y = "Órgãos")
```

## 2 - Qual é o valor gasto por cidade?

### Criando um dataframe com as 15 cidades que gastam mais

```{r}
p2 <- viagens %>%
  group_by(Destinos) %>%
  summarise(n = sum(Valor.passagens)) %>%
  arrange(desc(n)) %>%
  top_n(15)
```

```{r}
p2
```

### Alterando o nome das colunas

```{r}
names(p2) <- c("destino", "valor")
```

```{r}
p2
```

### Criando o gráfico

```{r}
ggplot(p2, aes(x = reorder(destino, valor), y = valor))+
  geom_bar(stat = "identity", fill = "#0ba791")+
  geom_text(aes(label = valor), vjust = 0.3, size = 3)+
  coord_flip()+
  labs(x = "Valor", y = "Destino")
options(scipen = 999)
```

## 3 - Qual é a quantidade de viagens por mês?

### Criando um dataframe com a quantidade de viagens por Ano/mês

```{r}
p3 <- viagens %>%
  group_by(data.inicio.formatada) %>%
  summarise(qtd = n_distinct(Identificador.do.processo.de.viagem))
```

```{r}
head(p3)
```

### Criando o gráfico

```{r}
ggplot(p3, aes(x = data.inicio.formatada, y = qtd, group = 1))+
  geom_line()+
  geom_point()
```
