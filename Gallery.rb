#!/usr/bin/env ruby

# Slowly porting Gallery.pl to a Sinatra application
#
# ------------
# Released under BSD 2-clause.
# Copyright 2014 Olivia Theze

require 'sinatra'
require 'liquid' 

configure do
    set :public_folder, "/home/olivia/code/galleryrb/test"
    set :views,         "/home/olivia/code/galleryrb/views"
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
    return
end

def MakeThumbs(images)
    #todo: go though the images array and create thumbnails
    return
end

$images = getImages()
$tillrefresh = 100

get '/' do
    #todo: create our nice index page
    if $tillrefesh == 0
        $tillrefresh = 100
        $images = getImages()
    else
        $tillrefresh = $tillrefresh - 1
    end
    liquid :index, :locals => { :test => $images }
end

get '/view/:image' do
    #todo: show a single image page, with previous/next stuff.
    if $images.member?(params[:image]) 
        liquid :single, :locals => { :image => params[:image] }
    else 

    end
end 

