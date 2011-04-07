class AddBrands < ActiveRecord::Migration
  def self.up
    Brand.create(:name=>"Carhartt"            ,:url=>"http://www.carhartt-europe.com"                  )
    Brand.create(:name=>"Levi's"              ,:url=>"http://www.levistrauss.com"                      )
    Brand.create(:name=>"Fred perry"          ,:url=>"http://www.fredperry.com"                        )
    Brand.create(:name=>"Wicked"              ,:url=>"http://www.wicked-fashion.com"                   )
    Brand.create(:name=>"Tribal"              ,:url=>"http://www.tribalgear.com"                       )
    Brand.create(:name=>"Dunderdon"           ,:url=>"http://www.dunderdon.com"                        )
    Brand.create(:name=>"Dickies"             ,:url=>"http://www.dickies.com"                          )
    Brand.create(:name=>"Hurley"              ,:url=>"http://www.hurley.com"                           )
    Brand.create(:name=>"Element"             ,:url=>"http://www.elementskateboards.com/clothes/"      )
    Brand.create(:name=>"Mattix"              ,:url=>"http://www.matixclothing.com"                    )
    Brand.create(:name=>"Merc"                ,:url=>"http://www.merc-clothing.com"                    )
    Brand.create(:name=>"Londsale"            ,:url=>"http://www.lonsdalelondon.com.au"                )
    Brand.create(:name=>"Hooligan"            ,:url=>"http://www.hooligan.de"                          )
    Brand.create(:name=>"Freeman T. Porter"   ,:url=>"http://www.freemantporter.fr"                    )
    Brand.create(:name=>"Amsterdamned"        ,:url=>""                                                )
    Brand.create(:name=>"Addict"              ,:url=>"http://www.addict.co.uk/"                        )
    Brand.create(:name=>"Reel"                ,:url=>"http://www.reelclothes.com"                      )
    Brand.create(:name=>"Hardcore united"     ,:url=>""                                                )
    Brand.create(:name=>'Doc martens'         , :url=>"http://www.drmartens.com/"                      )
  end

  def self.down
    Brand.find(:all).each do |b|
      b.destroy
    end
  end
end
