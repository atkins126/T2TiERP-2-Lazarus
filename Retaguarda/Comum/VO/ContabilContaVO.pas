{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [CONTABIL_CONTA] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2014 T2Ti.COM                                          
                                                                                
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
           t2ti.com@gmail.com                                                   
                                                                                
@author Albert Eije (t2ti.com@gmail.com)                    
@version 2.0                                                                    
*******************************************************************************}
unit ContabilContaVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL,
  PlanoContaVO, PlanoContaRefSpedVO;

type
  TContabilContaVO = class(TVO)
  private
    FID: Integer;
    FID_PLANO_CONTA: Integer;
    FID_CONTABIL_CONTA: Integer;
    FID_PLANO_CONTA_REF_SPED: Integer;
    FCLASSIFICACAO: String;
    FTIPO: String;
    FDESCRICAO: String;
    FDATA_INCLUSAO: TDateTime;
    FSITUACAO: String;
    FNATUREZA: String;
    FPATRIMONIO_RESULTADO: String;
    FLIVRO_CAIXA: String;
    FDFC: String;
    FORDEM: String;
    FCODIGO_REDUZIDO: String;
    FCODIGO_EFD: String;

    FPlanoContaNome: String;
    FPlanoContaSpedDescricao: String;
    FContabilContaPai: String;

    FPlanoContaVO: TPlanoContaVO;
    FPlanoContaRefSpedVO: TPlanoContaRefSpedVO;
    FContabilContaPaiVO: TContabilContaVO;

  published
    constructor Create; override;
    destructor Destroy; override;

    property Id: Integer  read FID write FID;

    property IdPlanoConta: Integer  read FID_PLANO_CONTA write FID_PLANO_CONTA;
    property PlanoContaNome: String read FPlanoContaNome write FPlanoContaNome;

    property IdContabilConta: Integer  read FID_CONTABIL_CONTA write FID_CONTABIL_CONTA;
    property ContabilContaPai: String read FContabilContaPai write FContabilContaPai;

    property IdPlanoContaRefSped: Integer  read FID_PLANO_CONTA_REF_SPED write FID_PLANO_CONTA_REF_SPED;
    property PlanoContaSpedDescricao: String read FPlanoContaSpedDescricao write FPlanoContaSpedDescricao;

    property Classificacao: String  read FCLASSIFICACAO write FCLASSIFICACAO;
    property Tipo: String  read FTIPO write FTIPO;
    property Descricao: String  read FDESCRICAO write FDESCRICAO;
    property DataInclusao: TDateTime  read FDATA_INCLUSAO write FDATA_INCLUSAO;
    property Situacao: String  read FSITUACAO write FSITUACAO;
    property Natureza: String  read FNATUREZA write FNATUREZA;
    property PatrimonioResultado: String  read FPATRIMONIO_RESULTADO write FPATRIMONIO_RESULTADO;
    property LivroCaixa: String  read FLIVRO_CAIXA write FLIVRO_CAIXA;
    property Dfc: String  read FDFC write FDFC;
    property Ordem: String  read FORDEM write FORDEM;
    property CodigoReduzido: String  read FCODIGO_REDUZIDO write FCODIGO_REDUZIDO;
    property CodigoEfd: String  read FCODIGO_EFD write FCODIGO_EFD;


    property PlanoContaVO: TPlanoContaVO read FPlanoContaVO write FPlanoContaVO;

    property PlanoContaRefSpedVO: TPlanoContaRefSpedVO read FPlanoContaRefSpedVO write FPlanoContaRefSpedVO;

    property ContabilContaPaiVO: TContabilContaVO read FContabilContaPaiVO write FContabilContaPaiVO;

  end;

  TListaContabilContaVO = specialize TFPGObjectList<TContabilContaVO>;

implementation

constructor TContabilContaVO.Create;
begin
  inherited;

  FPlanoContaVO := TPlanoContaVO.Create;
  FPlanoContaRefSpedVO := TPlanoContaRefSpedVO.Create;

  /// EXERCICIO
  /// se n�s criamos o objeto abaixo teremos um estouro de pilha.
  ///  ocorre que temos um auto-relacionamento aqui. caso o objeto abaixo
  ///  seja criado ele tentar� criar outro do mesmo tipo num la�o infinito
  ///  at� estourar a pilha. Pense em como resolver esse problema.
  //FContabilContaPaiVO := TContabilContaVO.Create;
end;

destructor TContabilContaVO.Destroy;
begin
  FreeAndNil(FPlanoContaVO);
  FreeAndNil(FPlanoContaRefSpedVO);
  FreeAndNil(FContabilContaPaiVO);

  inherited;
end;

initialization
  Classes.RegisterClass(TContabilContaVO);

finalization
  Classes.UnRegisterClass(TContabilContaVO);

end.
