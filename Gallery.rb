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
    set :image_refresh, 100
end
configure :production do
    set :public_folder, "/home/olivia/code/galleryrb/test"
    set :views,         "/home/olivia/code/galleryrb/views"
    set :image_refresh, 5000
end
$imgdir  = "full/"
$thmdir  = "thumbs/"

module SortMode
    None        = 0
    Alpha       = 1
    Modified    = 2
    Size        = 3
    DescAlpha   = 4
    DescModifed = 5
    DescSize    = 6
end

def getImages()
    Dir.chdir("#{settings.public_folder}/#{$imgdir}") do
        return Dir["*.{jp{e,}g,gif,png}"]
    end
end

def sortImages(images, dir=".", sortMode=SortMode::None)
    #todo: sort images by various modes 
    case sortMode
        when SortMode::None
            return images
        when SortMode::Alpha
            return images.sort
        when SortMode::DescAlpha
            return images.sort { |x,y| y <=> x }
        when SortMode::Modified
            return images.sort do |x,y|
                fx = File.new("#{dir}/#{x}","r")
                fy = File.new("#{dir}/#{y}","r")
                fx.stat <=> fy.stat
            end
        when SortMode::DescModified
            return images.sort do |x,y|
                fx = File.new("#{dir}/#{x}","r")
                fy = File.new("#{dir}/#{y}","r")
                fy.stat <=> fx.stat
            end
        when SortMode::Size
            return images.sort do |x,y|
                fx = File.new("#{dir}/#{x}","r")
                fy = File.new("#{dir}/#{y}","r")
                fx.stat.size <=> fy.stat.size
            end
        when SortMode::DescSize
            return images.sort do |x,y|
                fx = File.new("#{dir}/#{x}","r")
                fy = File.new("#{dir}/#{y}","r")
                fy.stat.size <=> fx.stat.size
            end 

    end
end

def MakeThumbs(images)
    #todo: go though the images array and create thumbnails
    return
end

$images = getImages()
$tillrefresh = settings.image_refresh

get '/' do
    #todo: create our nice index page
    if $tillrefesh == 0
        $tillrefresh = settings.image_refresh
        $images = getImages()

    else
        $tillrefresh = $tillrefresh - 1
    end
    liquid :index, :locals => { :images => $images }
end

get '/view/:image' do
    if $images.member?(params[:image]) 
        indexof = $images.index(params[:image])
        prev = indexof - 1
        if (indexof+1 > $images.length - 1) then nextimg = 0 else nextimg = indexof + 1 end
        liquid :single, :locals => { :image => params[:image], :prev => $images[prev], :next => $images[nextimg] }
    else 

    end
end 

