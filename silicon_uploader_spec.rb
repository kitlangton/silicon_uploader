require_relative 'silicon_uploader'

describe Silicon::Upload do
  it "accepts files" do
    upload = Silicon::Upload.new
    file = File.new("#{__dir__}/fixtures/Indirect\ Legacy\ 7_24\ Multistorage\ Phone_Package.zip")
    file2 = File.new("#{__dir__}/fixtures/7_24\ DP\ Phone\ MW_Package.zip")
    upload.add_files(file, file2)
    expect(upload.files).to eq [file, file2]
  end

  it "renames files" do
    Dir.chdir("#{Dir.home}/Downloads/August\ 15,\ 2015\ Upload\ Files")
    Dir.glob("*.zip")
  end

  xit "downloads files" do
    upload = Silicon::Upload.new
    name = "Simple Connected Device CTRI"
    iddev = "2a76f09e-1b70-402c-bf9d-529a25955140"
    idprod = "23b5f9fd-d162-4605-a953-583be34273f2"
    upload.download( name , iddev, :dev)
    upload.download( name, idprod, :prod)
  end

  it "uploads files" do
    # upload = Silicon::Upload.new
    Dir.chdir("#{Dir.home}/Downloads/August\ 15,\ 2015\ Upload\ Files")
    # files = Dir.glob("*.zip")
    # upload.upload(:dev)

    upload = Silicon::Upload.new
    upload.upload(:prod)
  end
end
