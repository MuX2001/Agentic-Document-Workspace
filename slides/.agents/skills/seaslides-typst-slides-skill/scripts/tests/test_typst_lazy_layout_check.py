import sys
import unittest
from pathlib import Path


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

from typst_lazy_layout_check import find_unsafe_lazy_layout_cols


class LazyLayoutCheckerTests(unittest.TestCase):
    def findings(self, source):
        return find_unsafe_lazy_layout_cols(source, Path("fixture.typ"))

    def test_multiple_direct_units_are_blockers(self):
        findings = self.findings(
            "#cols(lazy-layout: true)[#card-a() #v(1em) #card-b()][#card-c()]"
        )
        self.assertEqual(1, len(findings))
        self.assertEqual("blocker", findings[0].severity)
        self.assertIn("3 top-level", findings[0].reason)

    def test_builtin_unit_is_review_but_custom_component_is_not_noise(self):
        findings = self.findings("#cols(lazy-layout: true)[#text(\"x\")][#card()]")
        self.assertEqual(1, len(findings))
        self.assertEqual("review", findings[0].severity)
        self.assertIn("generic text wrapper", findings[0].reason)

    def test_plain_markup_and_generic_stack_wrapper_are_reviews(self):
        findings = self.findings(
            "#cols(lazy-layout: true)[plain text][#stack[#card-a()][#card-b()]]"
        )
        self.assertEqual(2, len(findings))
        self.assertTrue(all(item.severity == "review" for item in findings))
        self.assertIn("not a direct component", findings[0].reason)
        self.assertIn("generic stack wrapper", findings[1].reason)

    def test_true_marker_is_not_last_marker_wins(self):
        findings = self.findings(
            "#cols(lazy-layout: true, lazy-layout: false)[#a() #b()][#c()]"
        )
        self.assertEqual("blocker", findings[0].severity)

    def test_nested_lazy_cols_are_checked(self):
        findings = self.findings(
            "#cols(lazy-layout: true)[#cols(lazy-layout: true)[#a() #b()][#c()]][#d()]"
        )
        self.assertTrue(any(item.severity == "blocker" and "2 top-level" in item.reason for item in findings))

    def test_control_flow_is_review_not_false_blocker(self):
        findings = self.findings(
            "#cols(lazy-layout: true)[if ok { #a() } else { #b() }][#c()]"
        )
        self.assertTrue(findings)
        self.assertTrue(all(item.severity == "review" for item in findings))

    def test_dynamic_spread_is_review_not_assumed_one_column(self):
        findings = self.findings(
            "#cols(lazy-layout: true, ..items.map(item => card(item)))"
        )
        self.assertEqual(1, len(findings))
        self.assertEqual("review", findings[0].severity)
        self.assertIn("dynamically spread", findings[0].reason)

    def test_markup_quote_does_not_hide_later_call(self):
        findings = self.findings('["quoted markup"]\n#cols(lazy-layout: true)[#a() #b()][#c()]')
        self.assertTrue(any(item.severity == "blocker" for item in findings))

    def test_ordinary_cols_and_lazy_v_are_not_scanned(self):
        self.assertEqual([], self.findings("#cols[#card()[#lazy-v(1fr)]][#card()]"))


if __name__ == "__main__":
    unittest.main()
