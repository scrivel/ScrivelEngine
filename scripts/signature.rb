f = ARGV.shift
yui_pat = /\/\*\*.+\*\*\//m
m_pat = /@method[ \t]*([a-z]+)/i
p_pat = /@param[ \t]*\{(.+)\}[ \t]*([a-z]+)/i
r_pat = /@return[ \t]*([a-z]+)/i
s_pat = /@static/i
selectors = []
open(f).read.scan(yui_pat){|m|
  method = m_pat.match(m)
  method = method[1] if method
  static = s_pat.match(m)
  return_ = r_pat.match(m)
  return_ = return_[1] if return_
  if method
    sig = ""
    sig += static ? "+ " : "- "
    sig += return_ ? "(#{return_})" : "(void)"
    sig += method
    m.scan(p_pat){|param|
      type = param[0]
      arg = param[1]
      p type
      p arg
    }
  end
}
p selectors