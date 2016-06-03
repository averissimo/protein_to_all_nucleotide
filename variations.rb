require 'bio'
require 'byebug'

def build_rev_trans_el(el, prefix = [])
  table = Bio::CodonTable[1]

  nt_seq = table.revtrans(el)

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

fasta = nil
File.open('input.query', 'r') do |f|
  fasta = Bio::Alignment::MultiFastaFormat.new(f.read)
end

File.open('output.query', 'wb') do |f|
  fasta.entries.each_with_index do |entry, ix|
    seq = Bio::Sequence::AA.new(entry.seq)
    res = build_rev_trans(seq)
    puts "#{ix+1}/#{fasta.entries.size}: Writing all sequences of #{entry.entry_id}"
    count = build_seq(f, res, entry.entry_id, 1)
    puts "  #{count} reverse translation written"
  end
end
