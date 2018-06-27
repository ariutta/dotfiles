{ callPackage, fetchzip, desktop ? true }:

callPackage ./common.nix {
  inherit desktop;
  buildType = "huge";
    datasources = [
      # metabolites
      # WARNING: this is very large
      fetchzip {
        url = "http://bridgedb.org/data/gene_database/metabolites_20180508.bridge.zip";
        # TODO is this hash for the zipped or unzipped file?
        sha256 = "13l3p755k3k4vp2zg24fbsmprbgml75cg105qmzs85xipz92cqv4";
      }

      # a sample of one of the gene databases. there are many more.
      fetchzip {
        url = "http://bridgedb.org/data/gene_database/Ag_Derby_Ensembl_Metazoa_39.bridge.zip";
        sha256 = "0a35731irmcv0gk4jmn6s7w9v2xglm49zyivxvvh3p47qcf4b6ik";
      }

      # interactions
      fetchzip {
        url = "http://bridgedb.org/data/gene_database/interactions_20180425.bridge.zip";
        sha256 = "13n46vlmxwl2kzpgshcb1r5cw99arvy3m0ldcy0lc0pckyvv4cj4";
      }
    ];
}
