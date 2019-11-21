fn_scraper_telegram <- function(path) {
  
  
  ## Seleciona apenas a div com o histórico de mensagens:
  pagina_bruta <- path %>%
    read_html() %>%
    html_node(xpath = "/html/body/div/div[2]/div") 
  
  ## Conta quantos nós-filhos existem abaixo da div histórico:
  nodes <- pagina_bruta %>% 
    html_children() %>% 
    length()
  
  df <- NULL
  ## Loop para pegar apenas o conteúdo da div com classe 'message default clearfix':
  for (i in 1:(nodes-1)){
    
    classe_node <- pagina_bruta %>% 
      html_node(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]")) %>% 
      html_attr(name = "class") 
    
    if (classe_node == "message default clearfix"){
      
      data_hora <- pagina_bruta %>% 
        html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[2]/div[1]")) %>% 
        html_attr(name = "title")
      
      nome <- pagina_bruta %>% 
        html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[2]/div[2]")) %>% 
        html_text()
      
      classe_temp <- pagina_bruta %>% 
        html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[2]/div[3]")) %>% 
        html_attr(name = "class")
      
      if (classe_temp == "reply_to details") {
        
        msg <- pagina_bruta %>% 
          html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[2]/div[4]")) %>% 
          html_text()
        
      } else {
        
        msg <- pagina_bruta %>% 
          html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[2]/div[3]")) %>% 
          html_text()
        
      }
      
      
      temp_df <- data_frame(data_hora, nome, msg)
      df <- rbind(df, temp_df)
      
      print(paste0("Processando mensagem ", i, " de ", nodes))
      
    } else if (classe_node == "message default clearfix joined"){
      
      data_hora <- pagina_bruta %>% 
        html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[1]/div[1]")) %>% 
        html_attr(name = "title")
      
      # recebe a mesma informação do loop anterior
      nome <- nome
      
      classe_temp <- pagina_bruta %>% 
        html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[1]/div[2]")) %>% 
        html_attr(name = "class")
      
      if (classe_temp == "reply_to details") {
        
        msg <- pagina_bruta %>% 
          html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[1]/div[3]")) %>% 
          html_text()
        
      } else {
        
        msg <- pagina_bruta %>% 
          html_nodes(xpath = paste0("/html/body/div/div[2]/div/div[", i,"]/div[1]/div[2]")) %>% 
          html_text()
        
      }
      
      
      temp_df <- data_frame(data_hora, nome, msg)
      df <- rbind(df, temp_df)
      
      print(paste0("Processando mensagem ", i, " de ", nodes))
    }
    
  }
  

  ## retorno o data frame:
  return(df)
  
}
