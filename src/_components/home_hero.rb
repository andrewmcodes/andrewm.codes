# Homepage introduction block with the primary site message and call to action.
#
# Kept as a component so the homepage owns content choice while the design
# system owns the visual treatment.
class HomeHero < Base
  # One-off editorial clamp size (34–52px) tuned specifically for this H1.
  # Intentionally kept outside `Heading::HEADING_SIZES` (a fixed discrete
  # scale) rather than stretching that map for a single caller. Weight is
  # deliberately light per the approved "thin/display-weight H1s" hierarchy.
  def h1_class
    cx(
      "text-[clamp(34px,5vw,52px)] leading-[1.05] tracking-[-0.028em]",
      TEXT_WEIGHT[:light],
      "text-balance max-w-[680px] text-sage-12"
    )
  end
end
