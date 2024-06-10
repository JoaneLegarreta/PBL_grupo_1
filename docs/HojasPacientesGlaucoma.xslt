<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<html>
			<head>
				<title>Eyetech Glaucoma Resultados</title>
				<link rel="stylesheet" type="text/css" href="css/estilos.css"/>
				<link rel="stylesheet" type="text/css" href="css/Comun.css"/>
			</head>
			
			<body>
				<div class= "head">
			
					<div class= "logo">
						<a href="index.html" onclick="return confirmLogout()">EYETECH<img src="Logo.png" alt="Logo de la empresa" style="float:left; width:70px; margin-top:12.5px;"/></a>
					</div>
					
					<nav class="navegacion">
							<a href="index.html"  onclick="return confirmLogout()">Inicio</a>
							<a href="Servicios.html"  onclick="return confirmLogout()">Servicios</a>
							<a href="Conocenos.html"  onclick="return confirmLogout()">Conócenos</a>
							<a href="Contacto.html"  onclick="return confirmLogout()" >Contacto</a>
							<div class="cuadrado-vacio">
								<a href="Acceso_Eyetech.html" onclick="return confirmLogout()" class="active">CERRAR SESIÓN</a>
							</div>
					</nav>
					<script>
						function confirmLogout() {
							return confirm("¿Seguro que quieres cerrar la sesión?");
						}
					</script>
				</div>
				
				<header class= "content header">
				<h1></h1>
				<p></p>
				</header>
				
				<h1>DATOS CLÍNICOS</h1>
				<h3>RESULTADOS DE LAS PRUEBAS REALIZADAS A PACIENTES CON SOSPECHA DE GLAUCOMA</h3>
				<footer><p>A continuación se presentan los resultados de los exámenes de glaucoma realizados el mes anterior. Las imágenes afectadas por ruido han sido sometidas a un proceso de filtrado para asegurar un resultado óptimo. Los pacientes diagnosticados con glaucoma se resaltarán en color rojo para su identificación visual. Además, se mostrará una imagen completa del ojo del paciente.</p></footer>
				<table class="estilo-tabla">
					<tr bgcolor= "#ADD8E6">
						<th>Paciente ID</th>
						<th>Centro</th>
						<th>Fecha</th>
						<th>Glaucoma</th>
						<th>Imagen</th>
					</tr>
					<xsl:for-each select="Detector_Glaucoma/Paciente">
						<xsl:sort select="Fecha"/>
							<tr>
								<td><xsl:value-of select="@id"/></td>
								<td><xsl:value-of select="Centro"/></td>
								<td><xsl:value-of select="Fecha"/></td>	
																
								<xsl:choose>
									<xsl:when test="Resultados/Glaucoma = 'Si'">
										<td><FONT color="#F81714"><xsl:value-of select="Resultados/Glaucoma"/>*</FONT></td>
									</xsl:when>
									<xsl:otherwise>
										<td><xsl:value-of select="Resultados/Glaucoma"/></td>
									</xsl:otherwise>
								</xsl:choose>
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
				
				<footer class="footer">
					<p>© 2024 EYETECH</p>
					<p>Este sitio web es para uso exclusivo de personal autorizado. El acceso no autorizado está prohibido y puede ser objeto de sanciones legales.</p>
				</footer>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>