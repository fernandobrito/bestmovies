URL_BASE = "http://www.hagah.com.br/programacao-tv/jsp/"

def url(codigo)
  "#{URL_BASE}default.jsp?uf=1&action=programacao_canal&canal=#{codigo}&operadora=14&gds=1"
end

URL_HBO = { "HBO" => url("HBO"),
            "HBO e" => url("HB2"),
            "HBO Family" => url("HFA"),
            "HBO Family e" => url("HFE"),
            "HBO Plus" => url("HPL"),
            "HBO Plus e" => url("HPE"),
          }


URL_TELECINE = { "Telecine Action" => url("TC2"),
                 "Telecine Cult" => url("TC5"),
                 "Telecine Fun" => url("TC6"),
                 "Telecine Pipoca" => url("TC4"),
                 "Telecine Premium" => url("TC1"),
                 "Telecine Touch" => url("TC3")
               }


URL_HD = { "HBO HD" => url("HBH"),
           "Telecine HD" => url("TCH"),
           "Telecine Pipoca HD" => url("T4H"),
           "Max HD" => url("MHD")
         }


URL_OTHERS = { "AXN" => url("AXN"),
               # "Canal Brasil" => url("CBR"),  # lots of movies without record on imdb
               "TNT" => url("TNT"),
               "Universal Channel" => url("USA"),
               "SyFy" => url("SCI"),
               "Max Prime" => url("MAP"),
               "Max Prime e" => url("MPE"),
               "Hallmark" => url("HAL")
             }

