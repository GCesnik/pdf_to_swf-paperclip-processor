require "paperclip"
require "logger"
module Paperclip
    class PdfToSwf < Processor
    
    attr_accessor :file, :params, :format
    
    def initialize file, options = {}, attachment = nil
      super
      @file           = file
      @params         = options[:params]
      @current_format = File.extname(@file.path)
      @basename       = File.basename(@file.path, @current_format)
      @format         = options[:format]
    end

    def make
      @logger = logger || Logger.new(STDOUT)
      @logger.info "Test"
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      begin
        parameters = []
        parameters << @params
        parameters << ":source"
        parameters << ":dest"
        
        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")
        cmd = "-z -j 100 -qq -o "
        cmd << "/public/Test%.swf " 
        cmd << File.expand_path(src.path)
       
        #success = Paperclip.run("pdf2swf", parameters, :source => "#{File.expand_path(dst.path)}",:dest => File.expand_path(src.path))
        Paperclip.run("pdf2swf", cmd)
      rescue Cocaine::CommandLineError => e
        raise PaperclipError, "There was an error converting #{@basename} to swf"
      end
      dst
    end
    
  end
end