# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day17 do
  context "it solves the test cases" do
    subject(:run) { computer.run(program) }

    let(:program) { described_class::Parser.parse_program(raw_program) }
    let(:computer) { described_class::Computer.new(register_a, register_b, register_c) }

    let(:register_a) { 0 }
    let(:register_b) { 0 }
    let(:register_c) { 0 }

    context "test case 1" do
      let(:register_c) { 9 }
      let(:raw_program) { "2,6" }

      it "sets correct register values" do
        expect { run }.to change(computer, :register_b).from(0).to(1)
      end
    end

    context "test case 2" do
      let(:register_a) { 10 }
      let(:raw_program) { "5,0,5,1,5,4" }

      it "calculates the expected solution" do
        expect(run).to eq("0,1,2")
      end
    end

    context "test case 3" do
      let(:register_a) { 2024 }
      let(:raw_program) { "0,1,5,4,3,0" }

      it "calculates the expected solution" do
        expect(run).to eq("4,2,5,6,7,7,7,7,3,1,0")
        expect(computer.register_a).to eq(0)
      end
    end

    context "test case 4" do
      let(:register_b) { 29 }
      let(:raw_program) { "1,7" }

      it "sets correct register values" do
        expect { run }.to change(computer, :register_b).to(26)
      end
    end

    context "test case 5" do
      let(:register_b) { 2024 }
      let(:register_c) { 43690 }
      let(:raw_program) { "4,0" }

      it "sets correct register values" do
        expect { run }.to change(computer, :register_b).to(44354)
      end
    end

    context "for my test cases" do
      context "for bst" do
        let(:register_b) { 12 }
        let(:raw_program) { "2,5" }

        it "sets correct register values" do
          expect { run }.to change(computer, :register_b).from(12).to(4)
        end
      end

      context "for bdv" do
        let(:register_a) { 32 }
        let(:register_b) { 5 }
        let(:raw_program) { "6,5" }

        it "sets correct register values" do
          expect { run }.to change(computer, :register_b).from(5).to(1)
        end
      end

      context "for cdv" do
        let(:register_a) { 32 }
        let(:register_c) { 5 }
        let(:raw_program) { "7,6" }

        it "sets correct register values" do
          expect { run }.to change(computer, :register_c).from(5).to(1)
        end
      end
    end
  end

  context "it solves the calibration problem" do
    subject(:solution) { described_class::Computer.run(raw_input) }

    let(:raw_input) do
      <<~TXT.chomp
        Register A: 729
        Register B: 0
        Register C: 0

        Program: 0,1,5,4,3,0
      TXT
    end

    let(:expected_output) do
      "4,6,3,5,6,3,5,2,1,0"
    end

    it "matches the expected solution" do
      expect(solution).to eq(expected_output)
    end
  end
end
