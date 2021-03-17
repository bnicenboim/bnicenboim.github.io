# An optional custom script to run before Hugo builds your site.
# You can delete it if you do not need it.
snapshot <- readRDS("R/snapshot.RDS")
newsnapshot <- fileSnapshot(path = "content/mypub.bib", md5sum = TRUE)
changed <- changedFiles(snapshot, newsnapshot)
if(!is.null(changed$changes)){
  blogdown:::build_rmds("content/cv.Rmd")
  blogdown:::build_rmds("content/publications.Rmd")
  snapshot <- fileSnapshot(path = "content/mypub.bib", md5sum = TRUE)
  saveRDS(snapshot, "R/snapshot.RDS")
}