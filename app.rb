require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem "oj"
  gem "parallel"
  gem "faraday", "~> 0.15.4"
  gem "multi_json", "~> 1.0"
  gem "typhoeus", "~> 1.3.1", require: ['typhoeus', 'typhoeus/adapters/faraday']
end

module Giphy
  def self.conn
    @conn ||= Faraday.new(:url => "http://api.giphy.com") { |faraday| faraday.adapter :typhoeus }
  end

  def self.call(q)
    resp = conn.get("/v1/gifs/search", api_key: "wpIEMb2sMw3VrQnzZEXhnYdNxFCLsRLT", q: q, limit: 10)
    json = MultiJson.load(resp.body)
    json["data"].sum { |data| data["images"]["fixed_height_still"]["size"].to_i }
  end
end

queries = File.readlines("40.txt").map(&:chomp)

t = Time.now
p Parallel.map(queries, in_threads: 90, &Giphy.method(:call)).sum
p Time.now - t
