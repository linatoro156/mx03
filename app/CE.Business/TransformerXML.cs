using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.IO;
using System.Xml.Linq;

namespace CE.Business
{
    public class TransformerXML
    {
        private Dictionary<string, XslCompiledTransform> transforms = new Dictionary<string, XslCompiledTransform>();
        public string cadenaOriginal = string.Empty;
        public string cadenaOriginalComex = string.Empty;
        private XslCompiledTransform _xslCfdiCompilado = null;

        public TransformerXML(string rutaArchivoXSLT)
        {
            Load(rutaArchivoXSLT);
        }

        public void Load(string rutaArchivoXSLT)
        {
            //XslCompiledTransform transform = null;
            try
            {
                if (!transforms.TryGetValue(rutaArchivoXSLT, out _xslCfdiCompilado))
                {
                    _xslCfdiCompilado = new XslCompiledTransform();
                    _xslCfdiCompilado.Load(rutaArchivoXSLT);
                    transforms[rutaArchivoXSLT] = _xslCfdiCompilado;
                }
                //return transform;
            }
            catch (Exception lo)
            {
                throw new IOException("Excepci�n al inicializar la plantilla de transformaci�n de XML. Verifique la existencia del archivo: " + rutaArchivoXSLT, lo);
            }
        }

        /// <summary>
        /// Transforma el xml a cadena original
        /// </summary>
        /// <param name="archivoXml">Archivo xml a transformar.</param>
        /// <param name="transformer">Objeto que aplica un xslt al archivo xml.</param>
        /// <returns>False cuando hay al menos un error</returns>
        public string getCadenaOriginal(XmlDocument archivoXml, XslCompiledTransform transformer)
        {
            StringWriter writer = new StringWriter();
            try
            {
                transformer.Transform(archivoXml, null, writer);
                return(writer.ToString());
            }
            catch 
            {
                throw;
            }
        }

        public void getCadenaOriginal(XmlDocument comprobanteCfdiXml)
        {
            cadenaOriginal = getCadenaOriginal(comprobanteCfdiXml, _xslCfdiCompilado);

        }

        public void TransformXDocument(XDocument inputXml)
        {
            try
            {
                var sb = new StringBuilder();
                using (var writer = XmlWriter.Create(sb))
                {
                    _xslCfdiCompilado.Transform(inputXml.CreateReader(ReaderOptions.None), writer);
                    writer.Close();
                    writer.Flush();
                }
                cadenaOriginal = sb.ToString();
            }
            catch 
            {
                //handle the exception your way
                throw;
            }
        }
    }
}
