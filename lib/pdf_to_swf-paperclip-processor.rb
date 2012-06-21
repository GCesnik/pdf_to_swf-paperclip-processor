require "paperclip"
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
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      @logger = logger Logger.new(STDOUT)
      @logger.info "In Method"
      @logger.info File.expand_path(dst.path) 
      @logger.info File.expand_path(src.path)
      begin
        parameters = []
        parameters << @params
        parameters << ":source"
        parameters << ":dest"
        
        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")
      
        success = Paperclip.run("pdf2swf", parameters, :dest => File.expand_path(dst.path), :source => "#{File.expand_path(src.path)}")
      rescue Cocaine::CommandLineError => e
        raise PaperclipError, "There was an error converting #{@basename} to swf"
      end
      dst
    end
    
  end
end