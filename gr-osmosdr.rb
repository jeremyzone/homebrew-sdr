require "formula"

class GrOsmosdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"
  head "git://git.osmocom.org/gr-osmosdr"

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha1 "c218f5d8bc97b39497680f6be9b7bd093f696e89"
  end

  depends_on "cmake" => :build
  depends_on "gnuradio"
  depends_on "gr-iqbal"
  depends_on "librtlsdr"

  def install
     ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    python_args = ["install", "--prefix=#{libexec}"]
    %w[Cheetah lxml].each do |r|
      resource(r).stage { system "python", "setup.py", *python_args }
    end
    mkdir "build" do
      args = %W[
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make install"
    end
  end
end
