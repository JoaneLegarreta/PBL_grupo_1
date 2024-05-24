<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<html>
			<head>
				<title>Eyetech Glaucoma Resultados</title>
				<link rel="stylesheet" type="text/css" href="css/estilos.css"/>
			</head>
			
			<body>
				<img src="Logo.png" alt="Logo de la empresa" style="float:right; width:200px"/>
				<img src="Logo2.png" alt="Logo de la empresa" style="margin-left:25px; width:100px; margin-top:25px"/>
				<h1>DATOS CLÍNICOS</h1>
				<h3>RESULTADOS DE LAS PRUEBAS REALIZADAS A PACIENTES CON SOSPECHA DE GLAUCOMA</h3>
				<footer><p>A continuación se presentan los resultados de los exámenes de glaucoma realizados el mes anterior. Las imágenes afectadas por ruido han sido sometidas a un proceso de filtrado para asegurar un resultado óptimo. Los pacientes diagnosticados con glaucoma se resaltarán en color rojo para su identificación visual. Al final se mostrarán los pacientes con glaucoma con sus respectivas imagenes.</p></footer>
				<table class="estilo-tabla">
					<tr bgcolor ="#ADD8E6">
						<th>Paciente ID</th>
						<th>Edad</th>
						<th>Peso</th>
						<th>Altura</th>
						<th>Centro</th>
						<th>Fecha</th>
						<th>Glaucoma</th>
						<!--<th>Imagen</th>-->
					</tr>
					<xsl:for-each select="Detector_Glaucoma/Paciente">
						<xsl:sort select="Fecha"/>
						<tr>
							<td><xsl:value-of select="@id"/></td>
							<!-- <td><xsl:value-of select="Nombre"/></td> -->
							<td><xsl:value-of select="Edad"/></td>
							<td><xsl:value-of select="Peso"/></td>
							<td><xsl:value-of select="Altura"/></td>
							<td><xsl:value-of select="Centro"/></td>
							<td><xsl:value-of select="Fecha"/></td>	
							<!--<td><xsl:value-of select="Resultados/Calidad_Imagen"/></td>-->
							<!--<td><xsl:value-of select="Resultados/Glaucoma"/></td> -->
							<xsl:choose>
								<xsl:when test="Resultados/Glaucoma = 'Si'">
									<td><FONT color="#F81714"><xsl:value-of select="Resultados/Glaucoma"/>*</FONT></td>
								</xsl:when>
								<xsl:otherwise>
									<td><xsl:value-of select="Resultados/Glaucoma"/></td>
								</xsl:otherwise>
							</xsl:choose>
						</tr>
					</xsl:for-each>
				</table>
				<h2>Pacientes con glaucoma</h2>
				<table class="estilo2-tabla">
					<tr bgcolor= "#ADD8E6">
						<th>Paciente ID</th>
						<th>Centro</th>
						<th>Fecha</th>
						<th>Calidad de Imagen</th>
						<th>Imagen</th>
					</tr>
					<xsl:for-each select="Detector_Glaucoma/Paciente[Resultados/Glaucoma = 'Si']">
						<xsl:sort select="Fecha"/>
							<tr>
								<td><xsl:value-of select="@id"/></td>
								<td><xsl:value-of select="Centro"/></td>
								<td><xsl:value-of select="Fecha"/></td>	
								<td><xsl:value-of select="Resultados/Calidad_Imagen"/></td>								
								<td>
									<xsl:element name="img">
										<xsl:attribute name="src">
											<xsl:value-of select="Resultados/imagen/@ruta"/>
										</xsl:attribute>
										<xsl:attribute name="style"> width: 150px; height: auto;</xsl:attribute>									
									</xsl:element>
								</td>
							</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>