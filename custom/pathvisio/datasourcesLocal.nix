{ stdenv, fetchzip }:

# WARNING: some of these are very large!

with builtins;

let
  ensemblRelease = "91";
  ensemblFungiRelease = "39";
  ensemblMetazoaRelease = ensemblFungiRelease;
  ensemblPlantRelease = ensemblFungiRelease;
in
{
  # genes
  # TODO add the other gene databases.
  # http://bridgedb.org/data/gene_database/
  # get sha256 like this:
  # nix-prefetch-url --unpack http://bridgedb.org/data/gene_database/An_Derby_Ensembl_Fungi_39.bridge.zip
  # the supported organisms are listed here:
  # https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/organisms.txt

  "Anopheles gambiae" = {
    type = "genes";
    src = fetchzip rec {
      name = "Ag_Derby_Ensembl_Metazoa_${ensemblMetazoaRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0bp1p8pq60l369lm3zm3arb3bwmwzm364cf7i7238jkjm1cr2sdn";
    };
  };

  "Drosophila melanogaster" = {
    type = "genes";
    src = fetchzip rec {
      name = "Dm_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1fay033gixcn8fwg2qqzabghsrxsq1by4wy06lbd3c7fvyc99czg";
    };
  };

  "Homo sapiens" = {
    type = "genes";
    src = fetchzip rec {
      name = "Hs_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0y1fw0sz9s37m5wgxgrrqff5gbnrpbkl0i0wcyqhq29c3ygk0pv4";
    };
  };

  "Mus musculus" = {
    type = "genes";
    src = fetchzip rec {
      name = "Mm_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1ggbca04g1sp53288fn5vanrnf37lnb5h15xm90683ljr7mncq3a";
    };
  };

  interactions = {
    type = "interactions";
    src = fetchzip rec {
      name = "interactions_20180425";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1mvb3jh3slwc35xw6iiygjld0d6xjmhs786r5srac3wnnfa34hl5";
    };
  };

  metabolites = {
    type = "metabolites";
    src = fetchzip rec {
      name = "metabolites_20180508";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0prfvm7c91rc1hhp1nwz0l2s2z4d7g8rccdr64amqhq4v2f8bbp4";
    };
  };
}
