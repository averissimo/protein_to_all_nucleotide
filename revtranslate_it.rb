require 'bio'
require 'byebug'

#
class AA2NT
  #
  def initialize(table_num = 1)
    puts "Running with codon table: #{table_num}..."
    @table = Bio::CodonTable[table_num]
  end

  def revtrans(input_file = 'input.query', output_file = 'output.query')
    fasta = nil
    begin
      File.open(input_file, 'r') do |f|
        fasta = Bio::Alignment::MultiFastaFormat.new(f.read)
      end
    rescue
      puts 'Error: Please check that \'input.query\' file exists' \
        ' and in the Fasta format.'
    end

    File.open(output_file, 'wb') do |f|
      fasta.entries.each_with_index do |entry, ix|
        seq = Bio::Sequence::AA.new(entry.seq)
        res = build_rev_trans(seq)
        puts "  #{ix + 1}/#{fasta.entries.size}: Writing all sequences of " \
          "#{entry.entry_id}"
        count = build_seq(f, res, entry.entry_id, 1)
        puts "    #{count} reverse translation written"
      end
    end
  end

  def build_rev_trans_el(el, prefix = [])
    nt_seq = @table.revtrans(el)

    prefix << nt_seq
    prefix
  end

  def build_rev_trans(seq)
    prefix = []
    seq.each_char do |el|
      prefix = build_rev_trans_el(el, prefix)
    end
    prefix
  end

  # recursivo sem grandes requisitos de memoria
  def build_seq(f, res, name, id, prefix = '')
    if res.nil? || res.empty?
      f.write Bio::Sequence.auto(prefix).output_fasta("#{name}_#{id}")
      return id + 1
    end
    #
    combin = res.shift
    combin.each do |el|
      id = build_seq(f, res, name, id, prefix + el)
    end
    id
  end
end

codon_table = 1
begin
  codon_table = Integer(ARGV[0]) if ARGV.size > 0
rescue
  puts "Error: first argument must be a number and '#{ARGV[0]}' is not one."
  exit
end

myclass = AA2NT.new(codon_table)
myclass.revtrans
