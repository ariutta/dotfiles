{ lib, bundlerApp, cacert }:

bundlerApp {
  pname = "sqlint";
  gemdir = ./.;
  exes = [ "sqlint" ];

  gemConfig = {
    pg_query = attrs: {
      NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    };
  };

  meta = with lib; {
    description = "Simple SQL linter.";
    homepage    = https://github.com/purcell/sqlint;
    license     = licenses.mit;
    maintainers = [  ];
    platforms   = platforms.all;
  };
}
