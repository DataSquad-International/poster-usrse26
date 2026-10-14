"""Minimal .xlsx reader (standard library only): returns {sheet name: [rows]} of strings."""
import zipfile, re, csv, sys
import xml.etree.ElementTree as ET
ns={'m':'http://schemas.openxmlformats.org/spreadsheetml/2006/main','r':'http://schemas.openxmlformats.org/officeDocument/2006/relationships'}
def col(ref):
    n=0
    for ch in re.match(r'[A-Z]+',ref).group(0): n=n*26+ord(ch)-64
    return n-1
def read(path):
    z=zipfile.ZipFile(path)
    ss=[]
    if 'xl/sharedStrings.xml' in z.namelist():
        for si in ET.fromstring(z.read('xl/sharedStrings.xml')).findall('m:si',ns):
            ss.append(''.join(t.text or '' for t in si.iter('{%s}t'%ns['m'])))
    wb=ET.fromstring(z.read('xl/workbook.xml'))
    rels={r.get('Id'):r.get('Target') for r in ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))}
    out={}
    for sh in wb.find('m:sheets',ns):
        name=sh.get('name'); t=rels[sh.get('{%s}id'%ns['r'])]
        t=t.lstrip('/'); t=t if t.startswith('xl/') else 'xl/'+t
        rows=[]
        for row in ET.fromstring(z.read(t)).find('m:sheetData',ns):
            r=[]
            for c in row:
                i=col(c.get('r'))
                while len(r)<=i: r.append('')
                v=c.find('m:v',ns); typ=c.get('t')
                if typ=='s' and v is not None: val=ss[int(v.text)]
                elif typ=='inlineStr': val=''.join(x.text or '' for x in c.iter('{%s}t'%ns['m']))
                else: val=v.text if v is not None else ''
                r[i]=val
            rows.append(r)
        out[name]=rows
    return out
if __name__=='__main__':
    d=read(sys.argv[1])
    for name,rows in d.items():
        print('SHEET',repr(name),len(rows),'rows; widths',sorted({len(r) for r in rows}))
        print('header:',rows[0])
