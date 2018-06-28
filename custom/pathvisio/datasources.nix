{ stdenv, fetchzip }:

with builtins;

let
  version = "39";
in
{
  # a sample of one of the gene databases. there are many more.
  "Anopheles gambiae" = fetchzip rec {
    name = "Ag_Derby_Ensembl_Metazoa_${version}";
    url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
    #stripRoot = true;
    sha256 = "0bp1p8pq60l369lm3zm3arb3bwmwzm364cf7i7238jkjm1cr2sdn";

  #  #sha256 = "15qxd61nasgz8h3c15jri49mmj6wpirlhmsw716j6frn1v3nazh0";
  #  postFetch = ''
  #    pwd
  #    ls -la ./
  #    unzip $downloadedFile
  #    mkdir -p $out/
  #    mv ./${name}.bridge $out/datasource.bridge
  #  '';
  };

  "Homo sapiens" = fetchzip rec {
    name = "Hs_Derby_Ensembl_91";
    url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
    sha256 = "0y1fw0sz9s37m5wgxgrrqff5gbnrpbkl0i0wcyqhq29c3ygk0pv4";
  };

  interaction = fetchzip rec {
    name = "interactions_20180425";
    url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
    sha256 = "1mvb3jh3slwc35xw6iiygjld0d6xjmhs786r5srac3wnnfa34hl5";
  };

  # WARNING: this is very large
  metabolite = fetchzip rec {
    name = "metabolites_20180508";
    url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
    sha256 = "0prfvm7c91rc1hhp1nwz0l2s2z4d7g8rccdr64amqhq4v2f8bbp4";
  };
}
