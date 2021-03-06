{*******************************************************************************
Title: T2Ti ERP
Description:  VO  relacionado � tabela [PRODUTO_SUBGRUPO]

The MIT License

Copyright: Copyright (C) 2010 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

       The author may be contacted at:
           t2ti.com@gmail.com</p>

@author  ()
@version 1.0
*******************************************************************************}
unit ProdutoSubGrupoVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL,
  ProdutoGrupoVO;

type
  TProdutoSubGrupoVO = class(TVO)
  private
    FID: Integer;
    FID_GRUPO: Integer;
    FNOME: String;
    FDESCRICAO: String;

    FProdutoGrupoNome: String;
    FProdutoGrupoVO: TProdutoGrupoVO;

  published
    constructor Create; override;
    destructor Destroy; override;

  published
    property Id: Integer  read FID write FID;

    property IdGrupo: Integer  read FID_GRUPO write FID_GRUPO;

    property Nome: String  read FNOME write FNOME;
    property Descricao: String  read FDESCRICAO write FDESCRICAO;

    property ProdutoGrupoVO: TProdutoGrupoVO read FProdutoGrupoVO write FProdutoGrupoVO;


  end;

  TListaProdutoSubGrupoVO = specialize TFPGObjectList<TProdutoSubGrupoVO>;

implementation

constructor TProdutoSubGrupoVO.Create;
begin
  inherited;
  FProdutoGrupoVO := TProdutoGrupoVO.Create;
end;

destructor TProdutoSubGrupoVO.Destroy;
begin
  FreeAndNil(FProdutoGrupoVO);
  inherited;
end;

initialization
  Classes.RegisterClass(TProdutoSubGrupoVO);

finalization
  Classes.UnRegisterClass(TProdutoSubGrupoVO);

end.

