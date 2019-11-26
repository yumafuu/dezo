require "dezo/version"

module Dezo
  class Error < StandardError; end
  # Your code goes here...
  require 'net/http'
  require 'uri'
  require 'active_support/core_ext'

  GET_ID_ENDPOINT = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite"
  GET_ITEM_ENDPOINT = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite"

  class << self
    def search(word)
      is_japanese = word =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/
      dic_type = is_japanese ? "EdictJE" : "EJdict"
      search_service(dic_type, word)
    end

    def search_service(dic_type, word)
      id_url = GET_ID_ENDPOINT + id_params(dic_type, word)
      id_uri = URI.parse(URI.encode(id_url))
      id_response = Net::HTTP.get_response(id_uri)
      item_id = id_response.body.match(/<ItemID>(.+)<\/ItemID>/)[1] rescue return

      item_url = GET_ITEM_ENDPOINT + item_params(dic_type, item_id)
      item_uri = URI.parse(URI.encode(item_url))
      item_response = Net::HTTP.get_response(item_uri)

      words = CGI.unescape(item_response.body).match(/<div>(.+)<\/div>/)[1] rescue return

      list = words.tr("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z").split("\t")
      puts list.map{|item| "- #{item}"}
      puts ""
    end

    private

    def id_params(dic_type, word)
      { Dic: "#{dic_type}",
        Word: word,
        Scope: "HEADWORD",
        Match: "EXACT",
        Merge: "OR",
        Prof: "XHTML",
        PageSize: "20",
        PageIndex: "0",
      }.each_with_object("?"){|(k, v), url| url <<  "#{k}=#{v}&"}.chop
    end

    def item_params(dic_type, id)
      { Dic: "#{dic_type}",
        Item: id,
        Loc: "",
        Prof: "XHTML",
      }.each_with_object("?"){|(k, v), url| url <<  "#{k}=#{v}&"}.chop
    end
  end
end
