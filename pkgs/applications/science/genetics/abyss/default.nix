{ stdenv, fetchurl, autoconf , automake, bash,
  boost, gcc, glibc, sparsehash, sqlite, openmpi }:

stdenv.mkDerivation rec {
  name    = "abyss";
  version = "2.0.2";

  src = fetchurl {
    url     = "${meta.homepage}/releases/${version}";
    name    = "${name}-${version}.tar.gz";
    sha256  = "1pr2jh4gfh5n4y8b4pls9hr8l9yq8gr667aay94gp9n3xbnpcyyq";
  };

  buildInputs = [ autoconf automake boost gcc glibc sparsehash sqlite openmpi ];

  preConfigure = ''
  set -ex
  aclocal
  autoconf
  autoheader
  automake -a
  '';

  postFixup = ''
  substituteInPlace $out/bin/abyss-pe --replace SHELL=/bin/bash SHELL=${bash}/bin/bash
  substituteInPlace $out/bin/abyss-pe --replace "which mpirun" "which ${openmpi}/bin/mpirun"
  substituteInPlace $out/bin/abyss-bloom-dist.mk --replace SHELL=/bin/bash SHELL=${bash}/bin/bash
  substituteInPlace $out/bin/abyss-dida --replace "/bin/bash -c" "${bash}/bin/bash -c"
  '';

  meta = {
    inherit version;
    description = "Assembly By Short Sequences - a de novo, parallel, paired-end
      sequence assembler.";
    longDescription = "ABySS is a de novo, parallel, paired-end sequence
      assembler that is designed for short reads. The single-processor version
      is useful for assembling genomes up to 100 Mbases in size. The parallel
      version is implemented using MPI and is capable of assembling larger
      genomes.";
    homepage = "http://www.bcgsc.ca/platform/bioinfo/software/${name}";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ "Krofek" ];
  };
}
