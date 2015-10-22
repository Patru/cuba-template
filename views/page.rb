# encoding: UTF-8
require "fortitude"
require 'i18n'

class Page < Fortitude::Widget
  doctype :html5

  def head_content
    meta charset:'utf-8'
    rawtext csrf.meta_tag
    title page_title
    link href:'/assets/application.css', rel:'stylesheet', type:'text/css'
  end

  def menu_link(link, title)
    li do
      a href:link do
        text title
      end
    end
  end

  def navigation
    ul do
      menu_link '/', 'Home'
      menu_link '/about', 'About'
    end
  end

  def content
    doctype!
    html do
      head do
        head_content
      end
      body do
        nav do
          navigation
        end
        flash_display
        div class: main_div_class do
          body_content
        end
        div id:'footer' do
          footer_content
        end
      end
    end
  end

  def main_div_class
    'main'
  end

  def footer_content
    text "© Soft-Werker GmbH, 2015"
  end


  def flash_display
    if flash.has?(:error) or flash.has?(:notice)
      div class: :flash do
        if flash.has?(:error)
          p class: :error do
            text flash[:error]
          end
        end
        if flash.has?(:notice)
          p class: :notice do
            text flash[:notice]
          end
        end
      end
    end
  end

  def csrf_token
    {'csrf_token'=>csrf.token}
  end
end