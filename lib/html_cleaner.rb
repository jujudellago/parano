module HtmlCleaner

  def HtmlCleaner.format_user_text(input)
    return if input.nil?
    #RAILS_DEFAULT_LOGGER.error("\HtmlCleaner format_user_text input.strip #{input.strip} !\n")
    output = "#{input.strip} "

    # do some formatting
    output.gsub!(/\r\n/, "\n")       # remove CRLFs
    output.gsub!(/^$\s*/m, "\n")     # remove blank lins
    output.gsub!(/\n{3,}/, "\n\n")   # replace \n\n\n... with \n\n
    output.gsub!(/\n\n/, '</p><p>')  # embed stuff in paragraphs
    output.gsub!(/\n/, '<br/>')      # nl2br
    output.gsub!(/<p/, "\n<p")      # nl2br
    output.gsub!(/&lt;!--(.*?)--&gt;/, "") 
    output.gsub!(/<!--(.*?)-->/, "")      
    output.gsub!(/<table/, "<table cellspacing=\"0\" cellpadding=\"0\"  style=\"border-collapse: collapse\"")      
    return output
  end
end