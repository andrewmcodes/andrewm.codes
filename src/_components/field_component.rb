class FieldComponent < ApplicationComponent
  required :label, :name
  option :type, default: "test"

  def full_name
    options.fetch(:full_name) { "-> #{name}" }
  end

  def render_in(view_context)
    <<~HTML
      <field-component>
        <p>#{full_name}</p>
        <label>#{label}</label>
        <input type="#{type}" name="#{name}" />
      </field-component>
    HTML
  end
end
