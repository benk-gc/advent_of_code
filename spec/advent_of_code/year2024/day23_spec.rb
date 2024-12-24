# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day23 do
  context "solves the calibration problem for part 1" do
    subject(:solution) { described_class.new(raw_problem).solution_part1 }

    let(:raw_problem) do
      <<~TXT.chomp
        kh-tc
        qp-kh
        de-cg
        ka-co
        yn-aq
        qp-ub
        cg-tb
        vc-aq
        tb-ka
        wh-tc
        yn-cg
        kh-ub
        ta-co
        de-co
        tc-td
        tb-wq
        wh-td
        ta-ka
        td-qp
        aq-cg
        wq-ub
        ub-vc
        de-ta
        wq-aq
        wq-vc
        wh-yn
        ka-de
        kh-ta
        co-tc
        wh-qp
        tb-vc
        td-yn
      TXT
    end

    it "finds the correct solution" do
      expect(solution).to eq(7)
    end
  end
end
