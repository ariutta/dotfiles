{
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  pg_query = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yap90gyzrvljwyiq4wlbar8yhr8c1yrqwrkmc0395m469sram2m";
      type = "gem";
    };
    version = "0.13.5";
  };
  sqlint = {
    dependencies = ["pg_query"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wm81dgdmgc16b97bz73vm0wjd2m1ra1b40h0kwfd9wgrh9ig2al";
      type = "gem";
    };
    version = "0.1.7";
  };
}