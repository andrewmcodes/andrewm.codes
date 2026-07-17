target :site do
  signature "sig"
  configure_code_diagnostics(
    Steep::Diagnostic::Ruby::UnannotatedEmptyCollection => nil
  )

  check "plugins/og_helper.rb"
  check "plugins/site_builder.rb"
  check "src/_components/base.rb"
  check "src/_components/project_card.rb"
  check "src/_components/util/seo.rb"
end
