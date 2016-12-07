post_name <- "2016-11-22-collaboration-network-EU-fp7.md"
fix_md_imagetag(post_name)

fix_md_imagetag <- function(post_name){
  library(stringr)
  
  post_path <- str_c(getwd(), "/_posts/", post_name)
  
  if(file.exists(post_path)){
    lines <- read_lines(post_path)
    imgs <- str_match(lines, "^!\\[.*\\]\\((.*)\\)$")[,2]
    cat(str_c("Found ", sum(!is.na(imgs)), " images:\n"))
    cat(str_c(imgs[!is.na(imgs)], collapse = "\n"))
    lines[!is.na(imgs)] <- 
      str_c("<div class=\"img img--fullContainer img--20xLeading\" style=\"background-image: url(", 
            imgs[!is.na(imgs)], 
            ");\"></div>")
    write_lines(lines, post_path)
  }
}
