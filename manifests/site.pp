# include all entries defined under a "classes" entry in the hiera yaml files
include(lookup('classes', Array[String], 'unique'))
