module KudoFlagsHelper

  def kudo_type_helper kudo
    kudo.is_a?(KudoCopy) ? "1" : "2"
  end


end



