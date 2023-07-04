get.assoc.studies= function(platform_id){ #read the man; obtains all GSE codes associated with a platform
  Platform_meta <- GEOquery::getGEO(platform_id)
  GEOquery::Meta(Platform_meta)$series_id

}
