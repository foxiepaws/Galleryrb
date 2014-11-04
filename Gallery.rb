#!/usr/bin/env ruby

# Slowly porting Gallery.pl to a Sinatra application
#
# ------------
# Released under BSD 2-clause.
# Copyright 2014 Olivia Theze

require 'sinatra'

configure do
    set :public_folder, "/home/olivia/code/galleryrb/test"
    set :views,         "/home/olivia/code/galleryrb/views"
end
@imgdir  = "full/"
@thmdir  = "thumbs/"


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
    #todo: get images from fulldir.
    return
end

def sortImages(images, dir=".", sortMode=Gallery::SortMode::None)
    #todo: sort images by various modes 
    return
end

def MakeThumbs(images)
    #todo: go though the images array and create thumbnails
    return
end

get '/' do
    #todo: create our nice index page
    liquid :index, :locals => { :test => 'Olivia' }
end


get '/view/:image' do
    #todo: show a single image

end 

