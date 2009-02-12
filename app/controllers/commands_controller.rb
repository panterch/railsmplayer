# seb@jukebox:~/railsmplayer$ mplayer -input cmdlist
# MPlayer 1.0rc2-4.3.1-DFSG-free (C) 2000-2007 MPlayer Team
# CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ (Family: 15, Model: 43, Stepping: 1)
# CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 1
# Compiled with runtime CPU detection.
# seek                 Float [Integer]
# edl_mark            
# audio_delay          Float [Integer]
# speed_incr           Float
# speed_mult           Float
# speed_set            Float
# quit                 [Integer]
# pause               
# frame_step          
# pt_step              Integer [Integer]
# pt_up_step           Integer [Integer]
# alt_src_step         Integer
# loop                 Integer [Integer]
# sub_delay            Float [Integer]
# sub_step             Integer [Integer]
# osd                  [Integer]
# osd_show_text        String [Integer] [Integer]
# osd_show_property_te String [Integer] [Integer]
# volume               Float [Integer]
# balance              Float [Integer]
# use_master          
# mute                 [Integer]
# contrast             Integer [Integer]
# gamma                Integer [Integer]
# brightness           Integer [Integer]
# hue                  Integer [Integer]
# saturation           Integer [Integer]
# frame_drop           [Integer]
# sub_pos              Integer [Integer]
# sub_alignment        [Integer]
# sub_visibility       [Integer]
# sub_load             String
# sub_remove           [Integer]
# vobsub_lang          [Integer]
# sub_select           [Integer]
# sub_log             
# sub_scale            Float [Integer]
# get_percent_pos     
# get_time_pos        
# get_time_length     
# get_file_name       
# get_video_codec     
# get_video_bitrate   
# get_video_resolution
# get_audio_codec     
# get_audio_bitrate   
# get_audio_samples   
# get_meta_title      
# get_meta_artist     
# get_meta_album      
# get_meta_year       
# get_meta_comment    
# get_meta_track      
# get_meta_genre      
# switch_audio         [Integer]
# tv_start_scan       
# tv_step_channel      Integer
# tv_step_norm        
# tv_step_chanlist    
# tv_set_channel       String
# tv_last_channel     
# tv_set_freq          Float
# tv_step_freq         Float
# tv_set_norm          String
# tv_set_brightness    Integer [Integer]
# tv_set_contrast      Integer [Integer]
# tv_set_hue           Integer [Integer]
# tv_set_saturation    Integer [Integer]
# forced_subs_only     [Integer]
# dvb_set_channel      Integer Integer
# switch_ratio         [Float]
# vo_fullscreen        [Integer]
# vo_ontop             [Integer]
# file_filter          Integer
# vo_rootwin           [Integer]
# vo_border            [Integer]
# screenshot           [Integer]
# panscan              Float [Integer]
# switch_vsync         [Integer]
# loadfile             String [Integer]
# loadlist             String [Integer]
# run                  String
# change_rectangle     Integer Integer
# teletext_add_dec     String
# teletext_go_link     Integer
# gui_loadfile        
# gui_loadsubtitle    
# gui_about           
# gui_play            
# gui_stop            
# gui_playlist        
# gui_preferences     
# gui_skinbrowser     
# menu                 String
# set_menu             String [String]
# help                
# exit                
# hide                 [Integer]
# get_vo_fullscreen   
# get_sub_visibility  
# key_down_event       Integer
# set_property         String String
# get_property         String
# step_property        String [Float] [Integer]
# seek_chapter         Integer [Integer]
# set_mouse_pos        Integer Integer

class CommandsController < ApplicationController

  def pause
    Command.new('pause').execute
    render_nothing
  end

  def volume_up
    Command.new('volume 20').execute
    render_nothing
  end
   
  def volume_down
    Command.new('volume -20').execute
    render_nothing
  end

  def seek_left
    Command.new('seek -60 0').execute
    render_nothing
  end

  def seek_right
    Command.new('seek +60 0').execute
    render_nothing
  end

  def play
    url = params[:url]
    RECENTLY_PLAYED.insert(0, url)
    RECENTLY_PLAYED.uniq!

    cmd = 'loadfile'
    if (url =~ /\.m3u/) || (url =~ /\.pls/) || (url =~ /\.asx/)
      cmd = 'loadlist'
    end
    
    Command.new(cmd+' '+params[:url]).execute
    render :partial => 'recent'
  end

  protected

    def render_nothing
      render :nothing => true
    end 
end
