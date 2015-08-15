require 'capybara'
require 'clipboard'
require 'selenium-webdriver'
require 'highline/import'

module Silicon
  class Upload
    include Capybara::DSL

    DEV = 'http://165.254.199.10/Admin/login.aspx'
    PROD = 'http://165.254.199.7/Admin/login.aspx'

    attr_reader :files, :info

    def initialize
      @info = []
      @files = []
      Capybara.default_driver = :selenium
    end

    def add_files(*files)
      files.each do |file|
        @files << file
      end
    end

    def list
      click_link 'Manage S1 Templates'
      sleep 3
      links = all '.CatalogItemIDLink'
      links = links.map { |link| link['href']}
      links.take(@count).each do |link|
        visit link
        find('#ctl00__ContextTabs_ContentPlaceHolder1_ASPxPageControl1_T2T').click
        filename = find('#ctl00__ContextTabs_ContentPlaceHolder1_ASPxPageControl1__InfoGrid_DXDataRow2').all('.dxgv')[1].text
        id = find('#ctl00__ContextTabs_ContentPlaceHolder1_ASPxPageControl1__InfoGrid_DXDataRow5').all('.dxgv')[1].text
        @info << CardInfo.new(filename,id)
      end
    end

    def download(name, id, server)
      visit ( server == :dev ? DEV : PROD )
      login
      click_button 'Login'
      find('#ctl00__ContextTabs_ContentPlaceHolder1_ASPxPageControl1_T1T').click
      fill_in 'ctl00__ContextTabs_ContentPlaceHolder1_ASPxPageControl1__Grid_DXFREditorcol5_I', with: id
      sleep 1
      all('.dxeHyperlink_BlackGlass')[1].click
      click_link 'Download'
      sleep 3
      Dir.chdir("#{Dir.home}/Downloads")
      file = Dir.glob("S1Template*").sort_by { |x| File.mtime(x) }.reverse.first
      File.rename(file, "#{server.to_s.upcase} #{name}")
    end

    def upload(server)
      visit ( server == :dev ? DEV : PROD )
      login
      click_button 'Login'
      click_link 'Upload S1 Template'
      @count = ask("How many templates? ", Integer)
      list
      File.write("#{server.to_s.upcase}_output.txt", info.join("\n\n"))
    end

    private

    def login
      fill_in "ASPxRoundPanel1$_UserName", with: "verizon"
      fill_in "ASPxRoundPanel1$_Password", with: "verizon!"
    end
  end

  class CardInfo < Struct.new(:filename,:id)
    # def inspect
    #   "#{filename}\n#{id}"
    # end

    def to_s
      "#{filename}\n#{id}"
    end
  end
end
