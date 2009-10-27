module ServersHelper
  
  def package_attributes(package)
    attributes = package.attributes
    attributes.delete "MAXPARK"
    attributes.delete "MAXSUB"
    attributes.delete "MAXSQL"
    attributes.delete "MAXADDON"
    attributes.delete "MAXPOP"
    attributes.delete "MAXFTP"
    attributes.delete "MAXLST"

    attributes
  end
  
end