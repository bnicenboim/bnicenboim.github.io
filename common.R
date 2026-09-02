library(stringr)
# endcit<- "</cite></p>"
endcit<- "</cite></p>"
begcit<- "<p><cite>"

# ReadBib() errors on a .bib file with no entries, so return NULL for those
read_bib <- function(file){
    if(!file.exists(file)) return(NULL)
    if(!any(str_detect(readLines(file, warn = FALSE), "^\\s*@"))) return(NULL)
    RefManageR::ReadBib(file, check = FALSE)
}

# output() writes one bibs/<key>.bib per entry, so renaming or removing an entry
# leaves the old file behind. Delete any .bib whose name is not a current key.
clean_bibs <- function(keys, dirs = c("bibs", "docs/bibs")){
    stale <- character(0)
    for(d in dirs){
        if(!dir.exists(d)) next
        files <- list.files(d, pattern = "[.]bib$", full.names = TRUE)
        stale <- c(stale, files[!(sub("[.]bib$", "", basename(files)) %in% keys)])
    }
    if(length(stale)) file.remove(stale)
    invisible(stale)
}

# Every key across papers/*.bib, so nothing still in use is removed
all_bib_keys <- function(dir = "papers"){
    files <- list.files(dir, pattern = "[.]bib$", full.names = TRUE)
    keys <- unlist(lapply(files, function(f) names(read_bib(f))))
    unique(keys)
}

output <- function(bibobj, withbrackets = TRUE, hack = FALSE, flag = NULL){
    if(is.null(bibobj) || length(bibobj) == 0) return(invisible(NULL))
    for(i in 1:length(bibobj)){
        a <- capture.output(print(bibobj[i], .opts = list(no.print.fields=c("eprint","URL") )))
              if(hack){
            #do ugly hack to remove the sentence between em, which is repeated in the case of the misc
            a <- str_replace(a, "<em>(.*?)</em>\\.", "")
              }
        a <- paste(a, collapse = " ")
        a <- substr(a,nchar(begcit)+1,nchar(a)) # remore the <cite>
        a <- paste("<p>",a)
        a <- substr(a,1,nchar(a)-nchar(endcit))
        a <- str_replace(a, "(B\\. Nicenboim|Nicenboim, B\\.|Nicenboim, B)", "**\\1**")

        # A flag such as "short paper" goes first, before the other brackets
        if(!is.null(flag)){
            a <- paste0(a, ' **[', flag, ']** ')
        }

        if(withbrackets){
          bibfile <-  paste0("bibs/",names(bibobj[i]), ".bib")
                # My custom created fields:
                brackets <- list(eprint= bibobj[i]$eprint,
                                 read= bibobj[i]$url,
                     `code/data`=  bibobj[i]$customb,
                     poster = bibobj[i]$customc,
                     talk = bibobj[i]$customd,
                     bib = bibfile )
                RefManageR::WriteBib(bibobj[i], file = bibfile, verbose = FALSE)
                
                # Adding urls in case of need inside the []
                for(b in 1:length(brackets)){
                    if(!is.null(brackets[[b]])){
                        if(str_starts(brackets[[b]], "http") | str_ends(brackets[[b]], "pdf|bib" )){
                            a <- paste0(a,' **[**<a href="',brackets[[b]],'">**',names(brackets[b]),'**</a>**]** ')    
                        } else {  #This is mostly to create the [ talk ] with no link
                            a <- paste0(a,' **[**',brackets[b],'**]** ')
                        }
                        
                    }
                }
                }
        a <-paste0(a,"</p>")  #without the </cite>
        cat(a)
    }

}

