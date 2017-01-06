#This is to replace the markdown image tags with html ones adding proper class and style
fix_md_imagetag <- function(post_name){
  library(stringr)
  
  #ASSUMES working directory is in the blog folder tree root
  post_path <- str_c(getwd(), "/_posts/", post_name)
  
  if(file.exists(post_path)){
    lines <- read_lines(post_path)

    #find all includes images in markdown
    imgs <- str_match(lines, "^!\\[.*\\]\\((.*)\\)$")[,2]

    #output some info
    cat(str_c("Found ", sum(!is.na(imgs)), " images:\n"))
    cat(str_c(imgs[!is.na(imgs)], collapse = "\n"))

    #replace markdown with html tags
    lines[!is.na(imgs)] <- 
      str_c("<div class=\"img img--fullContainer img--20xLeading\" style=\"background-image: url(", imgs[!is.na(imgs)], ");\"></div>")
    write_lines(lines, post_path)
  }
}

post_name <- "2016-11-22-collaboration-network-EU-fp7.md"
post_name <- "2016-12-14-3D-density-visualisation.md"
fix_md_imagetag(post_name)
