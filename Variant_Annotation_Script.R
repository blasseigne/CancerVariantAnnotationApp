#RCR, 160113

#Input:
#InputVCF is VCF file for annotation
#AnnotationCache is variants cached for annotation
#UniqueVariantsOnly indicates if only unique variant should be annotated

#Output:A list with four items including number of variants matched, 
#number of variants missing, annotated variant table, and missing variant table

Annotate<-function(InputVCF, AnnotationCache, UniqueVariantsOnly=TRUE){
  #Error check if input has unexpected number of files
  if(ncol(InputVCF)<5){
    stop("Input VCF file has an unexpected number of columns")
  }
  
  #Generate Index for matching input variants with Cache
  InputVCF<-data.frame(InputVCF)
  InputVCF[,"Index"]<-paste(InputVCF[,1], InputVCF[,2], InputVCF[,4], InputVCF[,5], sep="_")
  UniqueInputVCF<-InputVCF[which(!duplicated(InputVCF[,"Index"])),]
  CommonIndex<-AnnotationCache[,"Index"][which(AnnotationCache[,"Index"]%in%UniqueInputVCF[,"Index"])]
  MissingIndex<-InputVCF[which(!InputVCF[,"Index"]%in%AnnotationCache[,"Index"]),]
  MissingIndex<-MissingIndex[,-which(colnames(MissingIndex)=="Index")]
  
  #Bind annotation to found variants and return found and missing inputs. 
  #Or error if no input variants matched.
  if(length(CommonIndex>0)){
    FoundInput<-UniqueInputVCF[which(UniqueInputVCF[,"Index"]%in%CommonIndex),]
    FoundInput<-FoundInput[order(FoundInput[,"Index"]),]
    FoundInput<-FoundInput[,-which(colnames(FoundInput)=="Index")]
    FoundCache<-AnnotationCache[which(AnnotationCache[,"Index"]%in%CommonIndex),]
    FoundCache<-FoundCache[order(FoundCache[,"Index"]),]
    FoundAnnotations<-cbind(FoundInput, FoundCache[,-which(colnames(FoundCache)=="Index")])
    
    #Annotate duplicate variants if necessary
    if(UniqueVariantsOnly==FALSE&nrow(InputVCF[which(duplicated(InputVCF[,"Index"])),])>0){
      
      #Remove duplicates not found in cache
      if(nrow(MissingIndex)>0){
      InputVCF<-InputVCF[-which(!InputVCF[,"Index"]%in%AnnotationCache[,"Index"]),]
      }
      
      #Loop through and append duplicates
      dups<-InputVCF[which(duplicated(InputVCF[,"Index"])),]
      while(nrow(dups)>0){
        if(length(which(duplicated(dups[,"Index"])))>0){
          currentDups<-dups[-which(duplicated(dups[,"Index"])),]
          dups<-dups[which(duplicated(dups[,"Index"])),]
          currentDups<-currentDups[order(currentDups[,"Index"]),]
          FoundCache<-FoundCache[which(FoundCache[,"Index"]%in%currentDups[,"Index"]),]
          FoundCache<-FoundCache[order(FoundCache[,"Index"]),]
          currentDups<-cbind(currentDups[,-which(colnames(currentDups)=="Index")], FoundCache[,-which(colnames(FoundCache)=="Index")])
          FoundAnnotations<-rbind(FoundAnnotations, currentDups)
        }
        if(length(which(duplicated(dups[,"Index"])))==0){
          currentDups<-dups[order(dups[,"Index"]),]
          dups<-dups[which(duplicated(dups[,"Index"])),]
          FoundCache<-FoundCache[which(FoundCache[,"Index"]%in%currentDups[,"Index"]),]
          FoundCache<-FoundCache[order(FoundCache[,"Index"]),]
          currentDups<-cbind(currentDups[,-which(colnames(currentDups)=="Index")], FoundCache[,-which(colnames(FoundCache)=="Index")])
          FoundAnnotations<-rbind(FoundAnnotations, currentDups)
        }
      }
      
    }
    return(list(Number_Found=nrow(FoundAnnotations), Number_Missing=nrow(MissingIndex), Found_Annotations=FoundAnnotations, Missing_Annotations=MissingIndex))
  }
  
  #Error handling if no variants match
  else{
    stop("Unable to match any variants")
  }
}


z<-Annotate(InputVCF, AnnotationCache)
z<-Annotate(InputVCF, AnnotationCache, UniqueVariantsOnly = FALSE)

write.table(InputVCF, "~/Desktop/CADD_TCGA/Example_InputVCF.txt", sep="\t", row.names=F, col.names=F)

