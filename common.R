library(stringr)
# endcit<- "</cite></p>"
endcit<- "</cite></p>"
begcit<- "<p><cite>"

output <- function(articles, withbrackets=T,hack=F){
    for(i in 1:length(articles)){
        a <- capture.output(print(articles[i]))
              if(hack){
            #do ugly hack to remove the sentence between em, which is repeated in the case of the misc
            a <- str_replace(a, "<em>(.*?)</em>\\.", "")
        }
        a <- paste(a,collapse=" ")
        a <- substr(a,nchar(begcit)+1,nchar(a)) # remore the <cite>
        a <- paste("<p>",a)
        a <- substr(a,1,nchar(a)-nchar(endcit))
        a <- str_replace(a, "(B\\. Nicenboim|Nicenboim, B\\.|Nicenboim, B)", "**\\1**")

        if(withbrackets){
                # My custom created fields:
                brackets <- list(paper= articles[i]$customa,
                     `code/data`=  articles[i]$customb,
                     poster = articles[i]$customc,
                     talk = articles[i]$customd)
        

                # Adding urls in case of need inside the []
                for(b in 1:length(brackets)){
                    if(!is.null(brackets[[b]])){
                        if(substr(brackets[[b]],1,4)=="http" | substr(brackets[[b]],nchar(brackets[[b]])-3,nchar(brackets[[b]]))==".pdf" ){
                            a <- paste0(a,' **[**<a href="',brackets[[b]],'">**',names(brackets[b]),'**</a>**]** ')    
                        } else {  #This is mostly to create the [ talk ] with no link
                            a <- paste0(a,' **[**',names(brackets[b]),'**]** ')
                        }
                        
                    }
                }}
        a <-paste0(a,"</p>")  #without the </cite>
        cat(a)
    }

}
