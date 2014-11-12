#!/usr/bin/env ruby

# Slowly porting Gallery.pl to a Sinatra application
#
# ------------
# Released under BSD 2-clause.
# Copyright 2014 Olivia Theze

require 'sinatra'
require 'liquid' 

configure :development do
    set :public_folder, "/home/olivia/code/galleryrb/test"
    set :views,         "/home/olivia/code/galleryrb/views"
    set :image_refresh, 10
    set :image_directory, "full/"
    set :thumbnail_directory, "thumbs/"
end
configure :production do
    set :public_folder, "/home/olivia/code/galleryrb/test"
    set :views,         "/home/olivia/code/galleryrb/views"
    set :image_refresh, 5000
    set :image_directory, "full/"
    set :thumbnail_directory, "thumbs/"
end

module SortMode
    None         = 0
    Alpha        = 1
    Modified     = 2
    Size         = 3
    DescAlpha    = 4
    DescModified = 5
    DescSize     = 6
# some aliases.
    Newest       = 5
    Oldest       = 2
    Biggest      = 6
    Smallest     = 3
end

def getImages()
    dir = "#{settings.public_folder}/#{settings.image_directory}"
    Dir.chdir(dir) do
        images =  Dir["*.{jp{e,}g,gif,png}"]
        return sortImages(images,dir,SortMode::Newest)
    end
end

def sortImages(images, dir=".", sortMode=SortMode::None)

    make_file = lambda do |f|
        return File.new("#{dir}/#{f}","r")
    end
    case sortMode
        when SortMode::None
            return images
        when SortMode::Alpha
            return images.sort
        when SortMode::DescAlpha
            return sortImages(images,dir,SortMode::Alpha).reverse
        when SortMode::Modified
            return images.sort do |x,y|
                fx = make_file.(x)
                fy = make_file.(y)
                fx.stat <=> fy.stat
            end
        when SortMode::DescModified
            return sortImages(images,dir,SortMode::Modified).reverse
        when SortMode::Size
            return images.sort do |x,y|
                fx = make_file.(x)
                fy = make_file.(y)
                fx.stat.size <=> fy.stat.size
            end
        when SortMode::DescSize
            return sortImages(images,dir,SortMode::Size).reverse
    end
end

def makeThumbs(images)
    #todo: switch to a library instead of this hack.
    dir = "#{settings.public_folder}/#{settings.thumbnail_directory}"
    images.each do |x|
        unless File.exists?("#{dir}/#{x}") then
            `convert #{settings.public_folder}/#{settings.image_directory}/#{x} -thumbnail 260x180 #{settings.public_folder}/#{settings.thumbnail_directory}/#{x}`
        end
    end
end

$images = getImages()
makeThumbs($images)
$tillrefresh = settings.image_refresh

get '/' do
    if $tillrefesh == 0
        $tillrefresh = settings.image_refresh
        $images = getImages()
        makeThumbs($images)
    else
        $tillrefresh = $tillrefresh - 1
    end
    liquid :index, :locals => { :images => $images, 
                                :thumbdir => settings.thumbnail_directory }
end

get '/view/:image' do
    if $images.member?(params[:image]) 
        indexof = $images.index(params[:image])
        prev = indexof - 1
        nextimg = (indexof+1 > $images.length - 1) ? 0 : indexof + 1
        liquid :single, :locals => { :image => params[:image],
                                     :prev => $images[prev], 
                                     :next => $images[nextimg], 
                                     :imagedir => settings.image_directory }
    else 
        halt 404
    end
end 

not_found do
    saferequest = {
        "accept" => request.accept,
        "body" => request.body,
        "scheme" => request.scheme,
        "script_name" => request.script_name,
        "path_info" => request.path_info,
        "port" => request.port,
        "request_method" => request.request_method,
        "query_string" => request.query_string,
        "content_length" => request.content_length,
        "media_type" => request.media_type,
        "host" => request.host,
        "referrer" => request.referrer,
        "user_agent" => request.user_agent,
        "cookies" => request.cookies,
        "url" => request.url,
        "path" => request.path,
        "ip" => request.ip,
        "env" => request.env                 
    }
    liquid :error404, :locals => { :request => saferequest }
end
