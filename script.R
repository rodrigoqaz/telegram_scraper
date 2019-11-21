library(tidyverse)
library(httr)
library(xml2)
library(rvest)
source("src.R")


path <- "chat/messages.html"
df_messages <- fn_scraper_telegram(path)
