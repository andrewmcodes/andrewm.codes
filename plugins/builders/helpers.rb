class Builders::Helpers < SiteBuilder
  def build
    helper "toc", :toc_template
  end

  def toc_template(*)
    <<~MD
      ## Table of Contents
      {:.no_toc}
      * …
      {:toc}
    MD
  end
end
