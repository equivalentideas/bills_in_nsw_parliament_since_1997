# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new

('A'..'Z').each do |letter|
  root = "http://www.parliament.nsw.gov.au"
  url = root + "/prod/parlment/nswbills.nsf/V3BillsListAll?open&vwCurr=V3AllByTitle&vwCat=#{letter}"
  page = agent.get(url)

  if !page.at('.bodyText').at(:table).nil?
    page.at('.bodyText').at(:table).search(:tr)[1..-1].each do |row|

      bill = {
        name: row.search(:td)[0].text,
        url: root + row.search(:td)[0].at(:a)[:href],
        house_of_origin: row.search(:td)[1].text
      }

      p bill
      # Write out to the sqlite database using scraperwiki library
      ScraperWiki.save_sqlite([:url], bill)
    end
  end
end
